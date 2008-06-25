require File.join(File.dirname(__FILE__),'helper')

def random_text(length=100)
  srand()
  i = rand(3)
  case(i)
    when 0
      text = "Lorem ipsum dolor sit amet, claritatem erat cum hendrerit vero dynamicus claram et sollemnes, mirum eua. Nam est vulputate consuetudium insitam, ex eu littera processus ii nihil at. Consequat ipsum quod te nisl mutationem non etiam laoreet. Nostrud adipiscing futurum augue, humanitatis, ut in ad legere facit, velit. Me per feugiat id, demonstraverunt dignissim eleifend notare eum te modo soluta. Me quam veniam est non luptatum aliquam erat, suscipit aliquip lobortis at."
    when 1
      text = "Her postcard nicked his science nimbly. Their art deepens the boss of wires behind crackers. One's valley's mail made my cold salad, very. Acuse finds our pond. The sense shifted one's home's conclusive chain, really silly. His store used her nice key, indeed ripped. Their forest of scion ruins surface unto sky. Though, fiber of crown slips my bill. Number considers the sauce with laws under fathers. One's funk preferred his insect, really logical. Slowly, her aquarium remembers their string of cheeses until spies outside houses."
    when 2
      text = "Who fauled? Their wilme's fibben outgrabed one's tulgey blurb very. Her smicken's chrysite proaned his flaust's gushish wabe. Our secher loved the selinal content, really second. Stilliny, glaven blave kists my valt of ordricks beside pontards. The snicker's plock unperred one's flift, buckily. Pightly, a grannet refints his acuse of scafts toward vulses off mords. Her blage morked their gyre, indeed morfitt."
    when 3
      text = "Kung ganon, ang aking pinakamalas na dilim ng tagumpay ay sinakay ng kanyang bato. Ang iyong busilak na kaibigan ng lupa ay sinama ng pinakamaganda na hangin. Ang ating pinakamalumbay na pangalan ng bunso ay ipinaalam ng aking pangamba. Ang pinakamatipuno na habagat ng reyna ay binawi ng ating pinakamaliwanag na pamahalaan. Ngunit, ang pinakamasakim na liwanag ng ibon ay ipinalabas ng kasama. Ang tinik ng matanda ay nilunod ng tauhan. Ang kanyang pinakamalakas na pangalan ng himala ay pinili ng pinakamasakim na panganay."
  end
  text[0,length]
end


forum_count = Forum.count
user_count = User.count

(forum_count*8).times do
  srand()
  forum_id = 1 + rand(forum_count)
  user_id = 1 + rand(user_count)
  Topic.create!(:forum_id => forum_id, :name => random_text(25), :user_id => user_id)
end

topic_count = Topic.count

(topic_count*user_count).times do
  srand()
  topic_id = 1 + rand(topic_count)
  user_id = 1 + rand(user_count)
  Post.create!(:topic_id => topic_id, :text => random_text(75), :user_id => user_id)  
end
