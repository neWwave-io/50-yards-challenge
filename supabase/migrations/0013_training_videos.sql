-- 0013_training_videos.sql
-- The Training Hub had been reading announcements with a video_link, which
-- meant a video and a notice competed for the same list. Videos are their own
-- thing — they are ordered, they stay up, and they are not news — so they get
-- their own table.

create table if not exists public.training_videos (
  id             uuid primary key default gen_random_uuid(),
  title          text not null,
  description    text,
  video_url      text not null,
  -- YouTube serves a still for every video, so this is usually derivable.
  thumbnail_url  text,
  sort_order     integer not null default 0,
  is_published   boolean not null default true,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

create index if not exists training_videos_order_idx
  on public.training_videos (sort_order)
  where is_published;

drop trigger if exists training_videos_set_updated_at on public.training_videos;
create trigger training_videos_set_updated_at
  before update on public.training_videos
  for each row execute function public.set_updated_at();

-- The two videos v1 shipped with, lifted from its How To Submit page rather
-- than invented. The stills are YouTube's own for those ids.
insert into public.training_videos (title, description, video_url, thumbnail_url, sort_order)
values
  (
    'How to Submit Lawns',
    'Every submission needs four photos: the yard before, the yard after, '
    'your child in action, and one with the homeowner.',
    'https://www.youtube.com/watch?v=_wjSYXi0Si8',
    'https://img.youtube.com/vi/_wjSYXi0Si8/hqdefault.jpg',
    0
  ),
  (
    'Safety First',
    'Watch this before your first mow. It covers handling the mower, the gear '
    'to wear, and what to check in a yard before you start.',
    'https://www.youtube.com/watch?v=d5gcToZFDmk',
    'https://img.youtube.com/vi/d5gcToZFDmk/hqdefault.jpg',
    1
  )
on conflict do nothing;

-- ─────────────────────────────────────────────────────────────────────────
-- Starter announcements.
--
-- ⚠️ Sample copy so the page is not empty in development. It is accurate
-- about how the challenge works, but it is not anybody's announcement —
-- replace it before real families see this project.
-- ─────────────────────────────────────────────────────────────────────────
insert into public.announcements (title, description, type, video_link, created_at)
values
  (
    'Welcome to the 50 Yard Challenge',
    'Mow 50 lawns free for people in your community who need a hand. Submit '
    'each one with photos and work your way from the orange shirt to the '
    'black one.',
    'article',
    null,
    now() - interval '6 days'
  ),
  (
    'Four photos with every lawn',
    'A submission needs the yard before, the yard after, a photo of you in '
    'action, and one with the homeowner. Missing photos hold your lawn in '
    'review.',
    'article',
    null,
    now() - interval '3 days'
  ),
  (
    'Watch the safety video first',
    'Before your first mow, watch the safety video in the Training Hub. It '
    'covers handling the mower and what to check in a yard before starting.',
    'video',
    'https://www.youtube.com/watch?v=d5gcToZFDmk',
    now() - interval '1 day'
  )
on conflict do nothing;
