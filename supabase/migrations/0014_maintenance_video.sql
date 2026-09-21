-- 0014_maintenance_video.sql
-- The third Training Hub video. Title is the video's own; the description is
-- the copy the Figma home page carries on this card.
--
-- It leads the hub because that is the video the design shows on the home
-- page. Reordering is one update to sort_order.
update public.training_videos set sort_order = sort_order + 1;

insert into public.training_videos (title, description, video_url, thumbnail_url, sort_order)
values (
  'Lawn Mower Maintenance For The 50 Yard Challenge',
  'Keep your lawn mower running safely, smoothly, and efficiently with these '
  'important lawn mower maintenance tips!',
  'https://www.youtube.com/watch?v=lHVh4NEkeIQ',
  'https://img.youtube.com/vi/lHVh4NEkeIQ/hqdefault.jpg',
  0
)
on conflict do nothing;
