-- 0012_badge_levels.sql
-- The badge ladder, which 0007 deliberately left empty because inventing the
-- thresholds would have put wrong numbers in front of members.
--
-- These are v1's, read from the Shirt System page it shipped with
-- (lib/pages/shirt_system): 10, 20, 30, 40 and 50 lawns. The shirt colours
-- are the v1 `ShirtLevel` enum — orange, green, blue, red, black — and they
-- are the order the home card's five washes follow.
--
-- One rename: v1's third tier was "Hero Mower"; the v2 design calls the same
-- tier "Super Mower". The threshold is unchanged, so nobody moves level.
insert into public.badge_levels (name, min_lawns, description, sort_order)
values
  ('Rookie Mower',  10, 'Ten lawns in — the orange shirt.', 0),
  ('Junior Mower',  20, 'Twenty lawns — the green shirt.',  1),
  ('Super Mower',   30, 'Thirty lawns — the blue shirt.',   2),
  ('Pro Cutter',    40, 'Forty lawns — the red shirt.',     3),
  ('Master Cutter', 50, 'Fifty lawns — the black shirt, and the challenge done.', 4)
on conflict (name) do update
  set min_lawns  = excluded.min_lawns,
      sort_order = excluded.sort_order;

-- profiles_apply_badge_level only fires when total_lawns is written, so
-- anyone who already has lawns needs their level filled in once.
update public.profiles p
   set current_badge_level_id = (
         select b.id from public.badge_levels b
          where b.min_lawns <= p.total_lawns
          order by b.min_lawns desc
          limit 1
       )
 where p.current_badge_level_id is distinct from (
         select b.id from public.badge_levels b
          where b.min_lawns <= p.total_lawns
          order by b.min_lawns desc
          limit 1
       );
