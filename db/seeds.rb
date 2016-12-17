
class SeedHelper
  SPORTS = ["Football", "Basketball", "Baseball", "Soccer", "Golf"]

  attr_reader :user_count

  def initialize(user_count: 10)
    @user_count = user_count
  end

  def seed
    user_count.times do
      user = User.create(
        email: Faker::Internet.email,
        name: Faker::StarWars.character,
        password: Faker::Internet.password
      )

      create_multiple_posts_per_user user
    end
  end

  def create_multiple_posts_per_user(user)
    rand(10).times do
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
