use ig_clone;

-- 1. Find the 5 oldest users.

select *
from users
order by created_at 
limit 5;

-- 2. What day of the week do most users register on?
-- We need to figure out when to schedule an ad campaign

select dayname(created_at) as day_of_week,count(*) as total_registration
from users
group by day_of_week
order by total_registration desc;

-- 3. We want to target our inactive users with an email campaign.
-- Find the users who have never posted a photo.

select u.username
from users u left join photos p on p.user_id=u.id
where p.image_url is null;

-- 4. We are running a new contest to see who can get the most likes in a single photo?
-- Who won?

select u.username,p.id,p.image_url,count(*) as total_likes
from likes l inner join photos p on l.photo_id=p.id
inner join users u on u.id=p.user_id
group by p.id
order by total_likes desc
limit 1;

-- 5. Our investors wants to know how many times does the average user post?

with A as(
select count(*) as total_users
from users),

B as (
select count(*) as total_photos
from photos)

select total_photos/total_users as average
from A inner join B;

select(select count(*)
from photos)/(select count(*) 
from users) as avg;

-- 6. A brand wants to know hich hashtags to use in a post?
-- What are the top 5 most commonly used hashtags?

 select t.tag_name,count(*) as total_used
 from tags t inner join photo_tags p on t.id=p.tag_id
 group by t.tag_name
 order by total_used desc
 limit 5;
 
 -- 7. We have a small problem with bots on our site.
 -- Find users who have liked every single photos on our site.
 
 select u.username,count(*) as num_likes
 from users u inner join likes l on u.id=l.user_id
 group by u.username
 having num_likes=(select count(*) from photos);