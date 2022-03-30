module BxBlockLogin
  class ApplicationConfigsController < ApplicationController

    def background_file
      @application_config = ApplicationConfig.config

      render json: ApplicationConfigSerializer.new(@application_config).serializable_hash,
            status: :ok
    end
  end
end
