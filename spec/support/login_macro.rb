module LoginMacro
  def login_with(user)
    visit '/sessions/new'
    within("form") do
      fill_in 'session_name', :with => user.name
      fill_in 'session_password', :with => user.password
    end
    click_button I18n.t("terms.sign_in")
  end
end
