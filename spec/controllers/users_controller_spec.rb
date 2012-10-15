require 'spec_helper'

describe UsersController do
  let(:user)    { create :user }
  let(:attrs)   { attributes_for :user }


  describe "#new" do
    subject { get(:new); self }
    its(:assigns, :user) { should be_a(User) }
  end

  describe "#create" do
    subject { post(:create, user: attrs); self }

    its(:assigns, :user) { should be_a(User) }

    context "on error" do
      let(:attrs) { attributes_for(:user, first_name: '') }
      its(:response) { should render_template :new }
    end

    context "on success" do
      let(:user) { stub("User", id: 123 ).as_null_object }
      before do
        User.should_receive(:new).and_return(user)
        user.should_receive(:save).and_return(true)
        user.should_receive(:working!)
      end
      its(:response) { should be_redirect }
      it "should login new user" do
        subject
        session[:user_id].should == user.id
      end
    end

  end

end