require "mandate"
require "yaml"
require "erb"
require 'aws-sdk-s3'

require 'invoker/download_files'

module Invoker
  def self.invoke
    s3_path = ARGV[0]
    data_path = Pathname.new(ARGV[1])

    input_dir = data_path / "input"
    output_dir = data_path / "iteration/output"
    FileUtils.mkdir_p(input_dir)
    FileUtils.mkdir_p(output_dir)

    DownloadFiles.(s3_path, input_dir)

    system("cd ../ruby-test-runner && bin/run.sh two_fer #{input_dir} #{output_dir}")#, out: "/dev/null", err: "/dev/null")
  end
end
