class Vote
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Integer, :serial => true
  property :poll_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :is_yes, Boolean, :default => 0, :nullable => false
  property :is_no, Boolean, :default => 0, :nullable => false
  property :is_adviser_decided, Boolean, :default => true, :nullable => false
  property :advisers_yes_count, Integer, :default => 0
  property :advisers_no_count, Integer, :default => 0
  
  attr_accessor :stance
  
  def stance=(value)
    case(value)
      when 'yes'
        attribute_set(:is_yes, true)
        attribute_set(:is_no, false)
        attribute_set(:is_adviser_decided, false)
      when 'no'
        attribute_set(:is_no, true)
        attribute_set(:is_yes, false)
        attribute_set(:is_adviser_decided, false)
      when 'undecided'
        attribute_set(:is_no, false)
        attribute_set(:is_yes, false)
        attribute_set(:is_adviser_decided, false)
      else
        attribute_set(:is_adviser_decided, true)
    end
  end
  
  class << self
    def cast_vote(new_vote)
      query = "\
        update votes set \
        is_yes = (yes_count + #{new_vote.is_yes} > no_count + #{new_vote.is_no}), \
        is_no = (yes_count + #{new_vote.is_yes} < no_count + #{new_vote.is_no}), \
        where poll_id = #{new_vote.poll_id} \
      "
      repository.adapter.execute(query)
    end
    
     
    def update_advisees_votes(old_vote, new_vote, advisees_ids)
      query = "\
        update votes set \
        is_yes = (advisers_yes_count + #{new_vote.is_yes} > advisers_no_count + #{new_vote.is_no}), \
        is_no = (advisers_yes_count + #{new_vote.is_yes} < advisers_no_count + #{new_vote.is_no}), \
        advisers_yes_count = advisers_yes_count + #{new_vote.is_yes > old_vote.is_yes ? 1 : 0}, \
        advisers_no_count = advisers_no_count + #{new_vote.is_no > old_vote.is_no ? 1 : 0} \
        where user_id in (#{advisees_ids.join(', ')}) \
        and poll_id = #{new_vote.poll_id} \
      "
      repository.adapter.execute(query)
    end
  end
  
  
=begin

  #yes = 1, no = -1, undecided = 0
  class << self
    def adviser_votes(new_vote)
#     old_vote , erase if exists + add vote 
    #thread above here
    
    SELECT users.user_id, <> FROM users INNER JOIN polls ON users.user_id = polls.user_id
    #where other_advisers_ids AND poll_id = 
    poll_id = #{new_vote.poll_id}
    user_ids = (#{advisees_ids.join(', ')})
    other_advisers_ids = #{user_ids.adviser_ids} - self_id
    position_of_advisers = #{other_advisers_ids.poll_id.position} 
    sum_each_pool_and_return_net_to_poll
#     get all advisee ids
      SELECT user_id 
#     check if they have selected 'let adviser decide'
      WHERE stance = 'let adviser decide'
#     get all adviser ids if yes
      <> adviser_id
#     check adviser ids for poll_id for position
      WHERE adviser_id.poll_id == poll_id
#     calculate net adviser position (doesn't need an old vote)
      ,(calculate in here) AS net_vote
#     assign user vote
      
      #Users
      id  |  username  |  email  |  person_id  |  is_adviser  | 
      
      #People
      id  |  full_name  |  dob  |  user_id  |  description  |  
      
      
      
      
      #Polls
      id  |  user_id  |  vote_id  |  count | total vote  |  question  |  
      
      #Votes
      id  |  poll_id  |  user_id  |  position  |  cb_adviser  |  
      
      #advising relationships
      id  |  adviser_id  |  advisee_id  |  created_at  |
    
       #joining multiple tables: select t1.col from t1 join t2 on t1.pk = t2.fk join t3 on t2.pk = t3.fk where t3.col = 'foo';     
      
      # 1) grab: adviser_id | advisee_id | votes.user_id == advisee_id AND votes.cb_adviser = 1 grab: advisee_id | adviser_id where polls.user_id == votes.user_id AND votes.user_id == adviser_id GET position and sum all positions, then +1 or -1 to count and add one to total vote
      
      one extra thing, need to see if Votes.user_id (for advisees) already exists, and if so, undo it and replace it 
      
      
      SELECT article, dealer, price
      FROM   shop s1
      WHERE  price=(SELECT MAX(s2.price)
      FROM shop s2
      WHERE s1.article = s2.article);

      VS 
      
      SELECT s1.article, dealer, s1.price
      FROM shop s1
      JOIN (
      SELECT article, MAX(price) AS price
      FROM shop
      GROUP BY article) AS s2
      ON s1.article = s2.article AND s1.price = s2.price;

      SELECT s1.article, s1.dealer, s1.price
      FROM shop s1
      LEFT JOIN shop s2 ON s1.article = s2.article AND s1.price < s2.price
      WHERE s2.article IS NULL;

      
      
      SELECT
      Votes.user_ihd 
      FROM 
      Votes 
      JOIN 
      Advising_relationships 
      ON Votes.user_id = Advising_relationships.adviser_id 
      
      
      
      
       people, users
       
      1) adviser votes
        a) creates a vote
          i) yes/no is checked and added to poll_id yes/now
        b) find all advisees
          i) advisers user_id from vote is checked for advisees(user_id)
        c) check if they selected 'let adviser decide'
          i) poll_id.advisees(user_ids).vote_id cb_adviser true? (multiple user_ids)
        d) If so, check what their advisers have voted (not counting our first adviser)
          i) poll_id.vote_id.advisee(user_id).advisers(user_ids) yes/no
        e) calculate net adviser votes
          i) yes = + 1, no = -1
        f)check for vote_id.advisee_id yes/no (from a previous assignment)  
          i) if different, update
      
      #put this all in as few queries as possible.  IE 1
      
      #FROM - The FROM clause joins two tables because the query needs to pull information from both of them. 
      
      #INNER JOIN - An INNER JOIN allows for rows from either table to appear in the result if and only if both tables meet the conditions specified in the ON clause.
      
      #ON - ON clause specifies that the name column in the pet table must match the name column in the event table.
      
      #Because the name column occurs in both tables, you must be specific about which table you mean when referring to the column. This is done by prepending the table name to the column name.
      
      #joining multiple tables: select t1.col from t1 join t2 on t1.pk = t2.fk join t3 on t2.pk = t3.fk where t3.col = 'foo';
      
      #SELECT s.* FROM person p INNER JOIN shirt s ON s.owner = p.id WHERE p.name LIKE 'Lilliana%' AND s.color <> 'white';
=begin
SELECT
    CONCAT(p1.id, p1.tvab) + 0 AS tvid,
    CONCAT(p1.christian_name, ' ', p1.surname) AS Name,
    p1.postal_code AS Code,
    p1.city AS City,
    pg.abrev AS Area,
    IF(td.participation = 'Aborted', 'A', ' ') AS A,
    p1.dead AS dead1,
    l.event AS event1,
    td.suspect AS tsuspect1,
    id.suspect AS isuspect1,
    td.severe AS tsevere1,
    id.severe AS isevere1,
    p2.dead AS dead2,
    l2.event AS event2,
    h2.nurse AS nurse2,
    h2.doctor AS doctor2,
    td2.suspect AS tsuspect2,
    id2.suspect AS isuspect2,
    td2.severe AS tsevere2,
    id2.severe AS isevere2,
    l.finish_date
FROM
    twin_project AS tp
    /* For Twin 1 */
    LEFT JOIN twin_data AS td ON tp.id = td.id
              AND tp.tvab = td.tvab
    LEFT JOIN informant_data AS id ON tp.id = id.id
              AND tp.tvab = id.tvab
    LEFT JOIN harmony AS h ON tp.id = h.id
              AND tp.tvab = h.tvab
    LEFT JOIN lentus AS l ON tp.id = l.id
              AND tp.tvab = l.tvab
    /* For Twin 2 */
    LEFT JOIN twin_data AS td2 ON p2.id = td2.id
              AND p2.tvab = td2.tvab
    LEFT JOIN informant_data AS id2 ON p2.id = id2.id
              AND p2.tvab = id2.tvab
    LEFT JOIN harmony AS h2 ON p2.id = h2.id
              AND p2.tvab = h2.tvab
    LEFT JOIN lentus AS l2 ON p2.id = l2.id
              AND p2.tvab = l2.tvab,
    person_data AS p1,
    person_data AS p2,
    postal_groups AS pg
WHERE
    /* p1 gets main twin and p2 gets his/her twin. */
    /* ptvab is a field inverted from tvab */
    p1.id = tp.id AND p1.tvab = tp.tvab AND
    p2.id = p1.id AND p2.ptvab = p1.tvab AND
    /* Just the screening survey */
    tp.survey_no = 5 AND
    /* Skip if partner died before 65 but allow emigration (dead=9) */
    (p2.dead = 0 OR p2.dead = 9 OR
     (p2.dead = 1 AND
      (p2.death_date = 0 OR
       (((TO_DAYS(p2.death_date) - TO_DAYS(p2.birthday)) / 365)
        >= 65))))
    AND
    (
    /* Twin is suspect */
    (td.future_contact = 'Yes' AND td.suspect = 2) OR
    /* Twin is suspect - Informant is Blessed */
    (td.future_contact = 'Yes' AND td.suspect = 1
                               AND id.suspect = 1) OR
    /* No twin - Informant is Blessed */
    (ISNULL(td.suspect) AND id.suspect = 1
                        AND id.future_contact = 'Yes') OR
    /* Twin broken off - Informant is Blessed */
    (td.participation = 'Aborted'
     AND id.suspect = 1 AND id.future_contact = 'Yes') OR
    /* Twin broken off - No inform - Have partner */
    (td.participation = 'Aborted' AND ISNULL(id.suspect)
                                  AND p2.dead = 0))
    AND
    l.event = 'Finished'
    /* Get at area code */
    AND SUBSTRING(p1.postal_code, 1, 2) = pg.code
    /* Not already distributed */
    AND (h.nurse IS NULL OR h.nurse=00 OR h.doctor=00)
    /* Has not refused or been aborted */
    AND NOT (h.status = 'Refused' OR h.status = 'Aborted'
    OR h.status = 'Died' OR h.status = 'Other')
ORDER BY
    tvid;

=end
=begin
SELECT field1_index, field2_index
    FROM test_table WHERE field1_index = '1'
UNION
SELECT field1_index, field2_index
    FROM test_table WHERE field2_index = '1';
=end
      
      #Using variables in a select: SELECT @min_price:=MIN(price)
      
      #t is also possible to store the name of a database object such as a table or a column in a user variable and then to use this variable in an SQL statement; however, this requires the use of a prepared statement. See Section 12.7, “SQL Syntax for Prepared Statements”, for more information. 
  
end