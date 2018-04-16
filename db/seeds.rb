class SeedHelper
  SPORTS = ["football", "basketball", "baseball"]

  attr_reader :user_count

  def initialize(user_count: 10)
    @user_count = user_count
  end

  def seed
    start = Time.now
    user_start_count = User.count
    post_start_count = Post.count
    image_start_count = Image.count
    comment_start_count = Comment.count
    vote_start_count = Vote.count
    puts "Seeding database..."

    create_users
    create_posts_comments_votes_followings

    puts "Finished in #{Time.now - start}"
    puts "Created:"
    puts "#{User.count - user_start_count} users"
    puts "#{Post.count - post_start_count} posts"
    puts "#{Image.count - image_start_count} images"
    puts "#{Comment.count - comment_start_count} comments"
    puts "#{Vote.count - vote_start_count} votes"
  end

  def create_users
    user_count.times do
      user = User.create(
        email: Faker::Internet.email,
        name: Faker::StarWars.character,
        short_bio: Faker::StarWars.quote,
        password: Faker::Internet.password
      )

      user.create_image_and_upload_to_s3(File.open(Dir["./lib/assets/seed_assets/*"].sample), "profile")
    end
  end

  def associate_followings(user)
    rand(10).times do
      user.followers.create follower_id: random_user_id
    end
  end

  def create_posts_comments_votes_followings
    users = User.all
    rand(12 * user_count).times do
      user = users.sample
      post = user.posts.create(
        sport: SPORTS.sample,
        text: [true, false].sample ? Faker::StarWars.quote : nil
      )

      if ([true, false].sample)
        post.create_image_and_upload_to_s3(File.open(Dir["./lib/assets/seed_assets/*"].sample))
      else
        post.update_attributes(text: Faker::StarWars.quote)
      end

      associate_followings user
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
    rand(10).times do
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
