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

  # Test Database interactions
  describe 'Database interactions' do
    context 'when saving a post' do
      it 'should be saved' do
        post.save
        expect(Post.count).to eq(1)
      end

      it 'should save a user' do
        post.save
        expect(User.count).to eq(1)
      end
    end

    context 'when destroying a post' do
      it 'should be destroyed' do
        post.save
        post.destroy
        expect(Post.count).to eq(0)
      end

      it 'should not destroyed a user with the post' do
        post.save
        post.destroy
        expect(User.count).to eq(1)
      end
    end
  end
end