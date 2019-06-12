# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :string
#  content    :string
#  user_id    :integer
#  sub_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
  validates :title, presence:true

  belongs_to :author, 
    foreign_key: :user_id,
    class_name: :User

  has_many :post_subs

  has_many :subs,
    through: :post_subs,
    source: :sub
end
