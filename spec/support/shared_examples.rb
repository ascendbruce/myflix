shared_examples "require_signed_in" do
  it "redirects to sign_in_path" do
    clear_current_user
    action
    expect(response).to redirect_to(sign_in_path)
  end
end
