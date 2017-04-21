
class SeedHelper
  SPORTS = ["football", "basketball", "baseball", "golf"]

  attr_reader :user_count

  def initialize(user_count: 10)
    @user_count = user_count
  end

  def create_users()
    user_count.times do
      User.create(
        email: Faker::Internet.email,
        name: Faker::StarWars.character,
        password: Faker::Internet.password
      )
    end
  end

  def seed
    create_users
    create_multiple_posts
  end

  def create_multiple_posts
    rand(100).times do
      user = User.all.sample
      post = user.posts.create(
        sport: SPORTS.sample,
        text: Faker::StarWars.quote
      )

      post.first_or_create_tags Faker::Hipster.words(rand(3))
      create_votes post
      create_multiple_comments_per_post post
    end
  end

  def create_multiple_comments_per_post(post)
    rand(10).times do
      comment = post.comments.create(
        user_id: random_user_id,
        message: Faker::StarWars.quote
      )

      create_votes comment
    end
  end

  def create_votes(model_instance)
    rand(50).times do
      model_instance.votes.create(
        user_id: random_user_id
      )
    end
  end

  def random_user_id
    User.all.sample.id
  end
end

SeedHelper.new.seed
