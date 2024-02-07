use ig_clone;

-- TASK 1) We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users
order by created_at desc
limit 5;

-- TASK 2) To target inactive users in an email ad campaign, find the users who have never posted a photo.
 
SELECT 
    username
FROM
    users
        LEFT JOIN
  photos ON users.id = photos.user_id
WHERE
    photos.id IS NULL;

-- TASK 3) Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?


SELECT 
    users.username,
    photos.id,
    photos.image_url,
    COUNT(*) AS total_likes
FROM
    likes
        JOIN
    photos ON photos.id = likes.photo_id
        JOIN
    users ON users.id = likes.photo_id
GROUP BY photos.id
ORDER BY total_likes DESC
LIMIT 3;

-- TASK 4) The investors want to know how many times does the average user post.

SELECT ROUND((SELECT COUNT(*) FROM Photos) / (SELECT COUNT(*) FROM Users)) as avg_posts;

-- TASK 5) A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

SELECT 
    tags.tag_name, COUNT(*) AS total
FROM
    photo_tags
        JOIN
    tags ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5; 

-- TASK 6) To find out if there are bots, find users who have liked every single photo on the site.

SELECT username, 
       Count(*) AS num_likes 
FROM   users 
       INNER JOIN likes 
               ON users.id = likes.user_id 
GROUP  BY likes.user_id 
HAVING num_likes = (SELECT Count(*) FROM photos);
                   
-- TASK 7)  Find the users who have created instagramid in may and select top 5 newest joinees from it

SELECT id,username,created_at
FROM users
WHERE MONTH(created_at) = 5
ORDER BY created_at DESC
limit 5;

-- TASK 8) Can you help me find the users whose name starts with c and ends with any
-- number and have posted the photos as well as liked the photos?

SELECT u.username
FROM users u
WHERE u.username REGEXP '^C.*[0-9]$'
  AND EXISTS (
    SELECT 1
    FROM photos p
    WHERE p.user_id = u.id
  )
  AND EXISTS (
    SELECT 1
    FROM likes l
    WHERE l.user_id = u.id
  );

-- TASK 9) Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.

SELECT u.username
FROM users u
WHERE u.id IN (
    SELECT p.user_id
    FROM photos p
    GROUP BY p.user_id
    HAVING COUNT(*) BETWEEN 3 AND 5
)
ORDER BY u.username
LIMIT 30;


