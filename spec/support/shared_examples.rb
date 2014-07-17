shared_examples "require_signed_in" do
  it "redirects to sign_in_path" do
    clear_current_user
    action
    expect(response).to redirect_to(sign_in_path)
  end
end

shared_examples "tokenable" do
  it "generates random token when generate_token is called" do
    object.generate_token
    expect(object.token).to be_present
  end
end
