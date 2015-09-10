require 'rails_helper'

describe ContactsController do

  describe 'GET #index' do
    context 'with params[:letter]' do
      it 'populates an array of contacts starting with the letter' do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')
        get :index, letter: 'S'
        expect(assigns(:contacts)).to match_array([smith])
      end
      it 'renders the :index template' do
        get :index, letter: 'S'
        expect(response).to render_template :index
      end
    end

    context 'without params [:letter]' do
      it 'populates an array of all contacts' do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')
        get :index
        expect(assigns(:contacts)).to match_array([smith, jones])
      end
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end
=begin
    We’re checking for two things here: First, that a persisted contact is found by the controller method and properly assigned to the specified instance variable. To accomplish this, we’re taking advantage of the assigns() method–checking that the value (assigned to @contact ) is what we expect to see. The second expectation may be self-explanatory, thanks to RSpec’s clean, readable syntax: The response sent from the controller back up the chain toward the browser will be rendered using the show.html.erb template. These two simple expectations demonstrate the following key concepts of controller testing:
   • The basic DSL for interacting with controller methods: Each HTTP verb has its own method (in these cases, get ), which expects the controller method name as a symbol (here, :show ), followed by any params ( id: contact ).
   • Variables instantiated by the controller method can be evaluated using assigns(:variable name) .
   • The finished product returned from the controller method can be evaluated through response .
=end


    describe 'GET #show' do
      it 'assigns the requested contact to @contact' do
        contact = create(:contact)
        get :show, id: contact
        expect(assigns(:contact)).to eq contact
      end

      it 'renders the :show template' do
        contact = create(:contact)
        get :show, id: contact
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      it 'assigns a new Contact to @contact' do
        get :new
        expect(assigns(:contact)).to be_a_new(Contact)
      end

      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested contact to @contact' do
        contact = create(:contact)
        get :edit, id: contact
        expect(assigns(:contact)).to eq contact
      end

      it 'renders :edit template' do
        contact = create(:contact)
        get :edit, id: contact
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      before :each do
        @phones = [
            attributes_for(:phone),
            attributes_for(:phone),
            attributes_for(:phone)
        ]
      end
      context 'with valid attributes' do
        it 'saves the new contact in the database' do
          expect{
            post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          }.to change(Contact, :count).by(1)
        end
        it 'redirects to contacts#show' do
          post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new contact in the database' do
          expect{
            post :create, contact: attributes_for(:invalid_contact)
          }.not_to change(Contact, :count)
        end
        it 're-renders the :new template' do
          post :create, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :new
        end
      end
    end

=begin
  On to our controller’s update method, where we need to check on a couple of things–
first, that the attributes passed into the method get assigned to the model we want
to update; and second, that the redirect works as we want. Let’s take advantage of
Rails 4.1’s use of the HTTP verb PATCH.
Points of interest:
• Since we’re updating an existing Contact, we need to persist something first.
We take care of that in the before hook, making sure to assign the persisted
Contact to @contact to access it later. (Again, we’ll look at more appropriate
ways to do this in later chapters.)
• The two examples that verify whether or not an object’s attributes are actually
changed by the update method–we can’t use the expect{} Proc here. Instead,
we have to call reload on @contact to check that our updates are actually
persisted. Otherwise, these examples follow a similar pattern to the one we
used in the POST-related specs.
=end

    describe 'PATCH #update' do
      before :each do
        @contact = create(:contact, firstname: 'Lawrence', lastname: 'Smith')
      end

      context 'with valid attributes'do
        it 'locates the requested @contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(assigns(:contact)).to eq(@contact)
        end
        it "changes the @contact's attributes" do
          patch :update, id: @contact, contact: attributes_for(:contact, firstname: 'Larry', lastname: 'Smith')
          @contact.reload
          expect(@contact.firstname).to eq('Larry')
          expect(@contact.lastname).to eq('Smith')
        end

        it 'redirects to the updated contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(response).to redirect_to @contact
        end
      end

      context 'without valid attributes' do
        it 'does not change the  contact\'s attributes' do
          patch :update, id: @contact, contact: attributes_for(:contact, firstname: 'Larry', lastname: nil)
          @contact.reload
          expect(@contact.firstname).not_to eq('Larry')
          expect(@contact.lastname).to eq('Smith')
        end

        it 're-renders the :edit template' do
          patch :update, id: @contact, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :edit
        end
      end
    end

=begin
  The first expectation checks to see if the destroy method in the controller actually deleted
the object (using the now-familiar expect{} Proc); the second expectation confirms
that the user is redirected back to the index upon success.
=end

    describe 'DELETE #destroy' do
      before :each do
        @contact = create(:contact)
      end

      it 'deletes the contact' do
        expect{
          delete :destroy, id: @contact
        }.to change(Contact, :count).by(-1)
      end
      it 'redirects to contacts#index' do
        delete :destroy, id: @contact
        expect(response).to redirect_to contacts_url
      end
    end

=begin
  describe 'PATCH hide_contact' do
    before :each do
      @contact = create(:contact)
    end
    it 'marks the contact as hidden' do
      patch :hide_contact, id: @contact
      expect(@contact.reload.hidden?).to be_true
    end

    it 'redirects to contacts#index' do
      patch :hide_contact, id:@contact
      expect(response).to redirect_to contacts_url
    end
  end
=end
end
