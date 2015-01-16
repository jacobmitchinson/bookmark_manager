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