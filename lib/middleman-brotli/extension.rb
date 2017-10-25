# Require core library
require 'middleman-core'

# Extension namespace
class Middleman::Brotli < ::Middleman::Extension
  option :exts, %w(.css .htm .html .js .svg .xhtml .otf .woff .ttf .woff2), 'File extensions to compress when building.'
  option :ignore, [], 'Patterns to avoid compressing'
  option :overwrite, false, 'Overwrite original files instead of adding .br extension.'

  class NumberHelpers
    include ::Padrino::Helpers::NumberHelpers
  end

  def initialize(app, options_hash={})
    super

    require 'brotli'
    require 'stringio'
    require 'find'
    require 'thread'
  end

  def after_build(builder)
    num_threads = 4
    paths = ::Middleman::Util.all_files_under(app.config[:build_dir])
    total_savings = 0

    # Fill a queue with inputs
    in_queue = Queue.new
    paths.each do |path|
      in_queue << path if should_brotli?(path)
    end
    num_paths = in_queue.size

    # Farm out compression tasks to threads and put the results in in_queue
    out_queue = Queue.new
    num_threads.times.each do
      Thread.new do
        while path = in_queue.pop
          out_queue << brotli_file(path.to_s)
        end
      end
    end

    # Insert a nil for each thread to stop it
    num_threads.times do
      in_queue << nil
    end

    old_locale = I18n.locale
    I18n.locale = :en # use the english localizations for printing out file sizes to make sure the localizations exist

    num_paths.times do
      output_filename, old_size, new_size = out_queue.pop

      next unless output_filename

      total_savings += (old_size - new_size)
      size_change_word = (old_size - new_size) > 0 ? 'smaller' : 'larger'
      builder.trigger :created, "#{output_filename} (#{NumberHelpers.new.number_to_human_size((old_size - new_size).abs)} #{size_change_word})"
    end

    builder.trigger :brotli, '', "Total brotli savings: #{NumberHelpers.new.number_to_human_size(total_savings)}"
    I18n.locale = old_locale
  end

  Contract String => [Maybe[String], Maybe[Num], Maybe[Num]]
  def brotli_file(path)
    input_file = File.open(path, 'rb').read
    output_filename = options.overwrite ? path : path + '.br'
    input_file_time = File.mtime(path)

    # Check if the right file's already there
    if !options.overwrite && File.exist?(output_filename) && File.mtime(output_filename) == input_file_time
      return [nil, nil, nil]
    end

    File.open(output_filename, 'wb') do |f|
      f.write(Brotli.deflate(input_file, quality: 11))
    end

    # Make the file times match, both for Nginx's brotli_static extension
    # and so we can ID existing files. Also, so even if the br files are
    # wiped out by build --clean and recreated, we won't rsync them over
    # again because they'll end up with the same mtime.
    File.utime(File.atime(output_filename), input_file_time, output_filename)

    old_size = File.size(path)
    new_size = File.size(output_filename)

    [output_filename, old_size, new_size]
  end

  private

  # Whether a path should be brotli'd
  # @param [Pathname] path A destination path
  # @return [Boolean]
  Contract Pathname => Bool
  def should_brotli?(path)
    path = path.sub app.config[:build_dir] + '/', ''
    options.exts.include?(path.extname) && options.ignore.none? { |ignore| Middleman::Util.path_match(ignore, path.to_s) }
  end
end
