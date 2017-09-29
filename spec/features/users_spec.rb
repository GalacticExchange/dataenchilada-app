require "spec_helper"

describe "users" do
  describe "visit edit page before login" do
    let(:url) { user_path }
    it_should_behave_like "login required"
  end

  describe "edit" do
    let!(:user) { build(:user) }

    before do
      login_with user
    end

    after do
      # reset password to the default
      FileUtils.rm_f(User::ENCRYPTED_PASSWORD_FILE)
    end

    describe 'to change password' do
      let(:current_password) { user.password }
      let(:password) { 'new_password' }

      before do
        visit user_path
        fill_in 'user[current_password]', with: current_password

        fill_in 'user[password]', with: password
        fill_in 'user[password_confirmation]', with: password_confirmation
        click_button I18n.t("terms.update_password")
      end

      context 'when valid new password/confirmation is input' do
        let(:password_confirmation) { password }

        it 'should update users password with new password' do
          expect(page).to have_css('.alert-success')
          expect(user.stored_digest).to eq user.digest(password)
        end
      end

      context 'when invalid new password/confirmation is input' do
        let(:password_confirmation) { 'invalid_password' }

        it 'should not update users password with new password' do
          expect(page).to have_css('.alert-danger')
          expect(user.stored_digest).to eq user.digest(current_password)
        end
      end
    end
  end
end
