require 'rails_helper'

describe Contact do
  it 'is valid with firstname, lastname and email' do
    contact = Contact.new(firstname: 'Raluca', lastname: 'WonderGirl', email: 'example@email.com')
    expect(contact).to be_valid
  end
  it 'is invalid without a firstname' do
    contact = Contact.new(firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end
  it 'is invalid without a lastname' do
    contact = Contact.new(lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end
  it 'is invalid without an email adress' do
    contact = Contact.new(email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")

  end
  it 'is invalid with a duplicate email address'  do
    Contact.create(firstname: 'John', lastname: 'Doe', email: 'example@email.com')
    contact = Contact.new(firstname: 'John', lastname: 'Tester', email: 'example@email.com')
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end
  it "returns a contact's full name as a string" do
    contact = Contact.create(firstname: 'John', lastname: 'Doe', email: 'example@email.com')
    expect(contact.name).to eq 'John Doe'
  end
  it 'returns a sorted array of results that match' do
    smith = Contact.create(firstname: 'John', lastname: 'Smith', email: 'jsmith@email.com')
    jones = Contact.create(firstname: 'Tim', lastname: 'Jones', email: 'tjones@email.com')
    johnson = Contact.create(firstname: 'John', lastname: 'Johnson', email: 'jjohnson@email.com')
    expect(Contact.by_letter("J")).to eq [johnson, jones]
  end
  it 'omits results that do no match' do
    smith = Contact.create(firstname: 'John', lastname: 'Smith', email: 'jsmith@email.com')
    jones = Contact.create(firstname: 'Tim', lastname: 'Jones', email: 'tjones@email.com')
    johnson = Contact.create(firstname: 'John', lastname: 'Johnson', email: 'jjohnson@email.com')
    expect(Contact.by_letter("J")).not_to include smith
  end
end
