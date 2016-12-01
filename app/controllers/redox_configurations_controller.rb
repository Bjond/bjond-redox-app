class RedoxConfigurationsController < ApplicationController
  before_action :set_redox_configuration, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def update
    if @redox_configuration.update(redox_configuration_params)
      redirect_to @redox_configuration, notice: 'Bjönd registration was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @redox_configuration.destroy
    redirect_to bjond_registrations_url, notice: 'redox Configuration was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redox_configuration
      @redox_configuration = RedoxConfiguration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def redox_configuration_params
      params.require(:redox_configuration).permit(:api_key, :secret, :sample_person_id)
    end

end
