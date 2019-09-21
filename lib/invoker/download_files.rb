class DownloadFiles
  include Mandate

  initialize_with :s3_path, :input_dir

  def call
    resp = s3_client.list_objects(bucket: submissions_bucket, prefix: s3_path)
    resp.contents.each do |object|
      fs_key = "#{input_dir}/#{object.key.gsub(/^#{s3_path}/, "")}"
      fs_dir = fs_key.split("/").tap(&:pop).join("/")

      FileUtils.mkdir_p(fs_dir)

      s3_client.get_object(
        response_target: fs_key,
        bucket: submissions_bucket,
        key: object.key
      )
    end
  end

  def s3_client
    @client ||= Aws::S3::Client.new(
      access_key_id: secrets["aws_access_key_id"],
      secret_access_key: secrets["aws_secret_access_key"],
      region: secrets["aws_region"]
    )
  end

  def submissions_bucket
    secrets["aws_submissions_bucket"]
  end

  memoize
  def secrets
    YAML::load(ERB.new(File.read(File.dirname(__FILE__) + "/../../config/secrets.yml")).result)["development"]
  end
end

