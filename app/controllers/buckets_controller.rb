class BucketsController < ApplicationController
  before_action :set_user
  before_action :set_bucket, only: [:edit, :update, :destroy]

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

  # GET /accounts/:account_id/buckets/:id/edit
  def edit; end

  # PATCH /accounts/:account_id/buckets/:id
  # rubocop: disable Metrics/AbcSize
  def update
    respond_to do |format|
      if @bucket.update(bucket_params)
        format.html { redirect_to account_path(@account) }
      else
        flash.now[:error] = @bucket.errors.messages.values.flatten.uniq
        format.js { render action: 'edit' }
      end
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

  # GET /accounts/:account_id/buckets/:bucket_id/confirm_destroy
  def confirm_destroy
    @account = @user.accounts.find(params[:account_id])
    @bucket = @account.buckets.find(params[:bucket_id])
  end

  # DELETE /accounts/:account_id/buckets/:id
  # rubocop: disable Metrics/AbcSize
  def destroy
    if params[:transfer_bucket_id]
      transfer_bucket = @account.buckets.find(params[:transfer_bucket_id])
      transfer_bucket.transfer_balance_before_destroy(@bucket)
    end

    if @bucket.destroy
      flash[:success] = "Successfully destroyed bucket."
    else
      flash[:error] = @bucket.errors.messages.values.flatten.uniq
    end
    redirect_to account_path(@account)
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

  def set_bucket
    @account = @user.accounts.find(params[:account_id])
    @bucket = @account.buckets.find(params[:id])
  end
end
