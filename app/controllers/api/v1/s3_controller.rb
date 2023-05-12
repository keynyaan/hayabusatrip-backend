module Api
  module V1
    class S3Controller < ApplicationController
      FILE_SIZE_LIMIT_BYTES = 5 * 1024 * 1024 # 5MB

      # idTokenの検証をスキップする
      skip_before_action :authenticate, only: [:upload]

      # S3にファイルアップロード
      def upload
        # ファイルの種類とサイズのバリデーション
        unless params[:file].content_type.start_with?('image/')
          return render json: { error: '画像ファイルを選択してください。' }, status: :unprocessable_entity
        end

        if params[:file].size > FILE_SIZE_LIMIT_BYTES
          return render json: { error: '画像ファイルのサイズは5MB以下にしてください。' }, status: :unprocessable_entity
        end

        s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
        obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(params[:filename])

        begin
          obj.upload_file(params[:file].tempfile, content_type: params[:file].content_type)
          render json: { location: obj.public_url }
        rescue => e
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end
  end
end
