class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  before_save :add_to_all_discussions

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :created_choices, :votes, :phone_number
  has_and_belongs_to_many :participating_decisions, :join_table => "decisions_participants",
                          :class_name => 'Decision', :association_foreign_key => "decision_id"
  has_many :created_decisions, :class_name => "Decision"
  has_many :created_choices, :class_name => "Choice", :foreign_key => "creator"
  has_many :votes, :foreign_key => "voter"
  has_many :discussion_entries, :group => 'discussion_id'
  has_many :discussions_created
  belongs_to :last_ref_decision, :class_name => "Decision", :foreign_key => "last_decision_ref"

  def add_to_all_discussions
    self.participating_decisions = Decision.all
  end

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(:email => data["email"]).first
      user
    else
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end
end
