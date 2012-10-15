require 'spec_helper'

describe User do

  describe "validation" do

    it { should  validate_presence_of  :email      }
    it { should  validate_presence_of  :first_name }
    it { should  validate_presence_of  :last_name  }

    describe "status" do
      context "new" do
        let(:user) { build :user }

        it "should not validate status" do
          user.status = ""
          user.valid?.should == true
        end

      end
      context "persisted" do
        let(:user) { create :user }

        it "should validate status" do
          user.status = ""
          user.valid?.should == false
          user.errors.messages.keys.should include :status
        end
      end
    end

    describe 'email uniqueness' do
      subject { create :user }
      it { should validate_uniqueness_of :email }
    end

    describe 'email format' do
      def validate_email email
        User.new(:email => email).tap {|u| u.valid?}.errors[:email].empty?
      end

      it "should have valid email" do
        validate_email('dnagir@example.com').should be_true
      end

      it "should have invalid email" do
        validate_email('some test string').should be_false
      end
    end

    describe "password" do
      context "new" do
        def validate_password pwd
          User.new(password: pwd, password_confirmation: pwd).tap {|u| u.valid?}.errors[:password].empty?
        end
        it "should validate password" do
          validate_password('123').should be_false
          validate_password('123456').should be_true
        end
      end
    end

  end

  describe "default scope" do
    before do
      create :user, email: 'z@example.com'
      create :user, email: 'a@example.com'
      create :user, email: 'k@example.com'
    end
    subject { User.all }
    it "should be ordered by email" do
      subject.first.email.should == 'a@example.com'
      subject.last.email.should == 'z@example.com'
    end
  end

  describe "before create callbacks" do
    describe "#set_status_for_new_user" do
      let(:user) { build :user }
      before do
        user.status = ''
        user.save
      end
      it "should set not_working status" do
        user.status.should == :not_working
      end
    end
  end

  describe "#full_name" do
    subject { create :user, first_name: "John", last_name: "Doe" }
    its(:full_name) { should == "John Doe" }
  end

  describe "#working!" do
    subject { create :user, status: :on_lunch }
    before do
      subject.working!
      subject.reload
    end
    its(:status) { should == :working}
  end

  describe "#not_working!" do
    subject { create :user, status: :on_lunch }
    before do
      subject.not_working!
      subject.reload
    end
    its(:status) { should == :not_working}
  end

end