class BackfillPasswordLengthToUsers < ActiveRecord::Migration[7.2]
  def up
    # 暗号化前のパスワード文字数は不明なので、
    # 仮に8文字とする場合
    User.where(password_length: nil).update_all(password_length: 8)
  end

  def down
    # ロールバック時はカラムの値をリセット
    User.update_all(password_length: nil)
  end
end
