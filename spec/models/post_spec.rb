require('rails_helper')

RSpec.describe Post, type: :model do
  let(:user) { User.create( first_name: 'John', last_name: 'Doe', email: 'john@gmail.com', password: '12341234' ) }
  let(:post) { described_class.new( title: 'Title', body: 'Body', user: user ) }

  # Test validations
  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(post).to be_valid
    end

    it 'is not valid without a title' do
      post.title = nil
      expect(post).to_not be_valid
    end

    it 'is not valid without a body' do
      post.body = nil
      expect(post).to_not be_valid
    end
  end

  # Test Associations
  describe 'Associations' do
    it { should belong_to(:user) }
  end
end