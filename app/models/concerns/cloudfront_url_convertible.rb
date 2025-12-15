module CloudfrontUrlConvertible
  extend ActiveSupport::Concern

  private

  def convert_to_cloudfront_url(url)
    return url if url.blank? || ENV['CLOUDFRONT_DOMAIN'].blank?

    # S3のURLパターンをCloudFront URLに置換
    url.gsub(%r{https://[\w.-]+\.s3[\w.-]*\.amazonaws\.com}, ENV['CLOUDFRONT_DOMAIN'])
  end
end
