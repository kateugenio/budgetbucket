class BucketsController < ApplicationController
  before_action :set_user

  # GET /accounts/:account_id/buckets/new
  def new
    respond_to do |format|
      @account = @user.accounts.find(params[:account_id])
      @bucket = @account.buckets.new

      format.js
    end
  end

  # POST /accounts/:account_id/buckets
  # rubocop: disable Metrics/AbcSize
  def create
    @account = @user.accounts.find(params[:account_id])
    @bucket = @account.buckets.new(bucket_params)
    respond_to do |format|
      if @bucket.save
        flash[:success] = "Successfully added a bucket!"
        format.html { redirect_to account_path(@account) }
      else
        flash.now[:error] = @bucket.errors.messages.values.flatten.uniq
        format.js { render action: 'new' }
      end
    end
  end
  # rubocop: enable Metrics/AbcSize

  # PATCH /accounts/:account_id/buckets/:id
  # rubocop: disable Metrics/AbcSize
  def update
    @account = @user.accounts.find(params[:account_id])
    @bucket = @account.buckets.find(params[:id])
    if @bucket.update(bucket_params)
      redirect_to account_path(@account)
    else
      @buckets = @account.buckets
      flash.now[:error] = @bucket.errors.messages.values.flatten.uniq
      render 'accounts/show'
    end
  end
  # rubocop: enable Metrics/AbcSize

  # PATCH /accounts/:account_id/buckets/:bucket_id/balance
  # rubocop: disable Metrics/AbcSize
  def update_balance
    @account = @user.accounts.find(params[:account_id])
    @bucket = @account.buckets.find(params[:bucket_id])
    return if @bucket.update(bucket_params)

    @error = @bucket.errors.messages.values.flatten.uniq
  end
  # rubocop: enable Metrics/AbcSize

  private

  def bucket_params
    params.require(:bucket).permit(
      :name,
      :current_balance,
      :target_balance,
      :bucket_type,
      :description
    )
  end

  def set_user
    @user = current_user
  end
end
