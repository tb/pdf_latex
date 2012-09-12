require "open-uri"

class PdfLatex
  @@config = {
      pdflatex_bin: '/usr/bin/pdflatex'
  }
  cattr_accessor :config
  attr_accessor :latex_template

  def initialize(latex_template_name)
    @pdflatex_bin ||= PdfLatex.config[:pdflatex_bin] unless PdfLatex.config.empty?
    @pdflatex_bin ||= (defined?(Bundler) ? `bundle exec which pdflatex` : `which pdflatex`).chomp
    raise "Location of pdflatex unknown." if @pdflatex_bin.empty?
    raise "Bad pdflatex path: #{@pdflatex_bin}" unless File.exists?(@pdflatex_bin)
    raise "#{@pdflatex_bin} is not executable" unless File.executable?(@pdflatex_bin)

    @build_path = File.join(Rails.root, 'tmp', "pdflatex-#{Time.now.to_i}#{rand(1000)}")
    @latex_template = File.join(Rails.root, 'lib', 'latex', "#{latex_template_name}.tex")
    raise "Bad LaTeX template path: #{@latex_template}" unless File.exists?(@latex_template)

    FileUtils.mkdir_p @build_path
    @output_path = File.join(@build_path, "#{latex_template_name}.pdf")
  end

  def render_to_string(options)
    threads = []

    options.each do |name,url|
      threads << Thread.new(name) do
        pdf_path = File.join(@build_path, "#{name}.pdf")
        open(pdf_path, "wb") do |file|
          open(url) do |content|
            file.write(content.read)
          end
        end
      end
    end

    threads.each do |t|
      t.join
    end

    system("cd #{@build_path} && #{@pdflatex_bin} #{@latex_template}")
    result_content = ""
    File.open(@output_path, 'rb') {|file| result_content = file.read }
    FileUtils.rm_rf(@build_path) if File.exists?(@build_path)
    result_content
  end

end