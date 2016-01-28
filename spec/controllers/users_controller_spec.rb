require "rails_helper"

describe UsersController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_user) }
  let(:user) { FactoryGirl.create(:user, confirmed_at: Time.now) }
  let(:admin) { FactoryGirl.create(:admin_user, confirmed_at: Time.now) }

  context "when not logged in" do
    describe "GET #index" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #show" do
      it "redirects to the sign in page" do
        get :show, id: user.to_param
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #new" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #edit" do
      it "redirects to the sign in page" do
        get :edit, id: user.to_param
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "POST #create" do
      it "redirects to the sign in page" do
        post :create, user: valid_attributes
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "PUT #update" do
      it "redirects to the sign in page" do
        put :update, id: user.to_param, user: {}
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE #destroy" do
      it "redirects to the sign in page" do
        delete :destroy, id: user.to_param
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  context "when logged in as a regular user" do
    before(:each) do
      login_user
    end

    describe "GET #index" do
      it "redirects to the root url" do
        get :index
        expect(response).to redirect_to(root_url)
      end

      it "displays an onauthorized flash message" do
        get :index
        expect(flash[:alert]).to eq(I18n.t("flash.users.unauthorized"))
      end
    end

    describe "GET #show" do
      it "redirects to the root url" do
        get :show, id: user.to_param
        expect(response).to redirect_to(root_url)
      end
    end

    describe "GET #new" do
      it "redirects to the root url" do
        get :new
        expect(response).to redirect_to(root_url)
      end
    end

    describe "GET #edit" do
      it "redirects to the root url" do
        get :edit, id: user.to_param
        expect(response).to redirect_to(root_url)
      end
    end

    describe "POST #create" do
      it "redirects to the root url" do
        post :create, user: valid_attributes
        expect(response).to redirect_to(root_url)
      end
    end

    describe "PUT #update" do
      it "redirects to the root url" do
        put :update, id: user.to_param, user: {}
        expect(response).to redirect_to(root_url)
      end
    end

    describe "DELETE #destroy" do
      it "redirects to the root url" do
        delete :destroy, id: user.to_param
        expect(response).to redirect_to(root_url)
      end
    end
  end

  context "when logged in as an admin" do
    before(:each) do
      login_admin
    end

    describe "GET #index" do
      it "assigns all users as @users" do
        get :index
        expect(assigns(:users)).to include(user)
      end
    end

    describe "GET #show" do
      it "assigns the requested user as @user" do
        get :show, id: user.to_param
        expect(assigns(:user)).to eq(user)
      end
    end

    describe "GET #new" do
      it "assigns a new user as @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "GET #edit" do
      it "assigns the requested user as @user" do
        get :edit, id: user.to_param
        expect(assigns(:user)).to eq(user)
      end
    end

    describe "POST #create" do
      describe "with valid params" do
        it "creates a new User" do
          expect do
            post :create, user: valid_attributes
          end.to change(User, :count).by(1)
        end

        it "assigns a newly created user as @user" do
          post :create, user: valid_attributes
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user)).to be_persisted
        end

        it "redirects to the created user" do
          post :create, user: valid_attributes
          expect(response).to redirect_to(User.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved user as @user" do
          post :create, user: invalid_attributes
          expect(assigns(:user)).to be_a_new(User)
        end

        it "re-renders the 'new' template" do
          post :create, user: invalid_attributes
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      describe "with valid params" do
        it "updates the requested user" do
          put :update, id: user.to_param, user: { first_name: "Davy" }
          user.reload
          expect(user.first_name).to eq("Davy")
        end

        it "assigns the requested user as @user" do
          put :update, id: user.to_param, user: valid_attributes
          expect(assigns(:user)).to eq(user)
        end

        it "redirects to the user" do
          put :update, id: user.to_param, user: valid_attributes
          expect(response).to redirect_to(user)
        end
      end

      describe "with invalid params" do
        it "assigns the user as @user" do
          put :update, id: user.to_param, user: invalid_attributes
          expect(assigns(:user)).to eq(user)
        end

        it "re-renders the 'edit' template" do
          put :update, id: user.to_param, user: invalid_attributes
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested user" do
        user.save!
        expect do
          delete :destroy, id: user.to_param
        end.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, id: user.to_param
        expect(response).to redirect_to(users_url)
      end
    end
  end
end
