require 'rails_helper'

describe Contact do
  it "has a valid factory" do
    expect(build(:contact)).to be_valid
  end
  it 'is invalid without a firstname' do
    contact = build(:contact, firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end
  it 'is invalid without a lastname' do
    contact = build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end
  it 'is invalid without an email address' do
    contact = build(:contact, email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")

  end
  it 'is invalid with a duplicate email address'  do
    # use FactoryGirl.create to persist an object in your application's test database
    create(:contact, email: "johndoe@email.com")
    # use FactoryGirl.build to store a new test object in memory
    contact = build(:contact, email: "johndoe@email.com")
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end
  it "returns a contact's full name as a string" do
    contact = build(:contact, firstname: "Jane", lastname: "Smith")
    expect(contact.name).to eq 'Jane Smith'
  end

  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end

  describe 'filter last name by letter' do
    before :each do
      @smith = create(:contact, firstname: 'John', lastname: 'Smith', email: 'jsmith@email.com')
      @jones = create(:contact, firstname: 'Tim', lastname: 'Jones', email: 'tjones@email.com')
      @johnson = create(:contact, firstname: 'John', lastname: 'Johnson', email: 'jjohnson@email.com')
    end

    context 'matching letters' do
      it 'returns a sorted array of results that match' do
        expect(Contact.by_letter("J")).to eq [@johnson, @jones]
      end
    end

    context 'non-matching letters' do
      it 'omits results that do no match' do
        expect(Contact.by_letter("J")).not_to include @smith
      end
    end
  end
end
