# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    # 失敗時のテスト
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'form[action="/signup"]'
  end

  # 成功時のテスト
  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    # 指定されたリダイレクト先に移動するメソッド
    follow_redirect!
    # 'users/show'のテンプレート表示テスト
    assert_template 'users/show'
    # flashのテスト
    assert_not flash.empty?
  end
  # test "the truth" do
  #   assert true
  # end
end
