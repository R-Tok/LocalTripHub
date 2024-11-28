class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])

    # 該当するユーザーが見つかっていれば、パスワードリセットの方法を記載したメールをユーザーに送信する（ランダムトークン付きのURL/有効期限付き）
    @user.deliver_reset_password_instructions! if @user

    redirect_to login_path, success: "パスワードリセット手順を送信しました"
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    not_authenticated if @user.blank?

    # the next line makes the password confirmation validation work
    @user.password_confirmation = params[:user][:password_confirmation]

    # パスワードと確認用パスワードの一致を確認
    if params[:user][:password].blank? || params[:user][:password_confirmation].blank?
      @user.errors.add(:password, "と確認用パスワードを入力してください")
      render action: "edit"

    elsif params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add(:password_confirmation, "が一致しません")
      render action: "edit"

    elsif params[:user][:password].length < 6
      @user.errors.add(:password, "は6文字以上である必要があります")
      render action: "edit"

    # the next line clears the temporary token and updates the password
    elsif @user.change_password(params[:user][:password])
      redirect_to login_path, success: "パスワードを変更しました"
    else
      render action: "edit"
    end
  end
end
