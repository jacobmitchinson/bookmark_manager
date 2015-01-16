feature 'User recovers password' do 

  before(:each) do 
    user = User.create(email: "test@test.com",
                password: 'test',
                password_confirmation: 'test')
  end

  scenario 'when pressing reset it generates a token' do  
    expect{ request_token }.to change{User.first(:email => 'test@test.com').password_token}
  end

  scenario 'when the user enters the token, it can reset the password' do 
    # I will request a token
    # Then I will press a link 
    # And will take me to a page to change my password
    # Validate the token and connect it with a user
    # Then I will enter my new password along with a confirmation password 
    # I will then press submit
    # My password will be changed 

    expect{ update_password }.to change{User.first(:email => 'test@test.com').password_digest}
  end

  def request_token
    visit '/users/reset'
    fill_in 'email', :with => 'test@test.com'
    click_button 'submit'
  end
 
  def update_password
    request_token
    user = User.first(:email => 'test@test.com')
    token = user.password_token
    visit "/users/reset/#{token}"
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'password'
    click_button 'submit'
    
  end

end