# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    unless @user.valid?
      render :new and return # renderの2回処理を防ぐため一つ目のところで条件式がfalseの時にメソッドを強制終了させる
    end
    session["devise.regist_data"] = {user: @user.attributes} #インスタンスメソッドから取得できる値をオブジェクト型からハッシュ型に変換

    # coockieの使用上としてネスト2段目以降はシンボル型の指定ができなくなる
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    @address = @user.build_address # @userに紐づくインスタンス変数を生成

    render :new_address # @addressを定義してから次のアクションのビューへ遷移する
  end

  def create_address
    @user = User.new(session["devise.regist_data"]["user"])
    @address = Address.new(address_params)
    unless @address.valid?
      render :new_address and return #こちらも2回処理を防ぐためにreturnを使って強制終了させる
    end
    @user.build_address(@address.attributes)
    @user.save
    # セッションとはデータを一時的に記憶するためのもの。
    # 登録したセッションのデータは不要なので削除する必要がある。
    session["devise.regist_data"]["user"].clear
    # ここまでは新規登録は完了

    # ログインがまだできていないので、sign_inメソッドを使ってログインする。
    sign_in(:user,@user)
  end

  private
  def address_params
    params.require(:address).permit(:postal_code, :address)
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
