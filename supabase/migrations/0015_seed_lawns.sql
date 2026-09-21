-- 0015_seed_lawns.sql
-- Sample lawns, so the home page has something to show.
--
-- ⚠️ Development data. Everything on the home page except announcements is
-- derived from this table — the ring, the badge level, total hours, the day
-- streak, the week tracker, the neighbour tiles and the activity feed — so
-- with none of it the page reads as broken rather than new. Delete before
-- real families arrive:
--     delete from public.lawns where notes = 'seed';
--
-- The day offsets are chosen to give each profile a believable shape: runs of
-- consecutive days for a streak, some gaps, and a few in the current week.
-- The counts put profiles on different badge levels so the challenge card's
-- five washes can be seen.
do $$
declare
  v_profile   record;
  v_offset    integer;
  v_offsets   integer[];
  v_who       text;
  v_index     integer;
  -- Weighted rather than one each: the neighbour rings compare a category
  -- against the busiest one, so an even split would draw six identical rings.
  v_categories text[] := array[
    'Elderly', 'Elderly', 'Elderly', 'Elderly',
    'Single Parent', 'Single Parent', 'Single Parent',
    'Veteran', 'Veteran',
    'Active Duty', 'Active Duty',
    'First Responder',
    'Disabled'
  ];
begin
  for v_profile in
    select id, email from public.profiles
  loop
    v_offsets := case v_profile.email
      -- 23 lawns: Junior Mower.
      when 'haha@gmail.com' then array[
        0,1,3,4,5,6,8,9,10,12,13,14,16,17,19,20,22,24,26,28,30,33,36]
      -- 12 lawns: Rookie Mower, with a run of three ending today.
      when 'panha1@gmail.com' then array[0,1,2,5,6,9,12,13,14,15,20,25]
      -- 7 lawns: still unranked, which is worth seeing too.
      when 'nbaghs@gmail.com' then array[1,2,3,8,11,15,18]
      when 'kimhengpanha@gmail.com' then array[2,7,14,21]
      -- panha@gmail.com keeps none, so the empty states stay reachable.
      else array[]::integer[]
    end;

    v_index := 0;
    foreach v_offset in array v_offsets loop
      v_who := v_categories[1 + (v_index % array_length(v_categories, 1))];

      insert into public.lawns (
        profile_id, who_for, hours_taken, status, created_at, verified_at, notes
      )
      values (
        v_profile.id,
        v_who,
        -- Between half an hour and two and a half.
        round((0.5 + (v_index % 5) * 0.5)::numeric, 2),
        -- Today's is still waiting on an admin, which is why the streak can
        -- count a day the lawn total does not.
        case when v_offset = 0 then 'pending'::public.lawn_status
             else 'approved'::public.lawn_status end,
        now() - make_interval(days => v_offset),
        case when v_offset = 0 then null
             else now() - make_interval(days => v_offset) end,
        'seed'
      );

      v_index := v_index + 1;
    end loop;
  end loop;
end $$;
