class FindingsController < ApplicationController
  def index
    @my_findings = policy_scope(Finding)
    @findings = Finding.all
    @markers = @findings.geocoded.map do |finding|
      {
        lat: finding.latitude,
        lng: finding.longitude,
        info_window: render_to_string(partial: "popup", locals: { finding: finding })
      }
    end
  end

  def show
    @finding = Finding.find(params[:id])
    authorize @finding
  end

  def new
    # @animal = Animal.find(params[:id])
    @finding = Finding.new
    authorize @finding
  end

  def create
    @finding = Finding.new(finding_params)
    @finding.user = current_user
    authorize @finding
  end

  def edit
    authorize @finding
  end

  def update
    authorize @finding
  end

  def destroy
    authorize @finding
    @finding.destroy
    redirect_to findings_path, status: :see_other
  end

  private

  def finding_params
    params.require(:finding).permit(:date, :photo, :comment)
  end
end
