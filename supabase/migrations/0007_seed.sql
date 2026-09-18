-- 0007_seed.sql
-- Only seeds values that are factual and independent of the Firestore export.
--
-- NOT seeded here, on purpose:
--   badge_levels     — the real tiers and their min_lawns thresholds come from
--                      the Firestore `shirt_levels` collection. Inventing them
--                      would put wrong numbers in front of users.
--   mowed_categories — comes from settings.allow_mowed_categories.
--   find_lawn_tips   — comes from settings.find_lawns.

insert into public.app_settings (id) values (true) on conflict (id) do nothing;

insert into public.us_states (code, name) values
  ('AL','Alabama'),        ('AK','Alaska'),         ('AZ','Arizona'),
  ('AR','Arkansas'),       ('CA','California'),     ('CO','Colorado'),
  ('CT','Connecticut'),    ('DE','Delaware'),       ('DC','District of Columbia'),
  ('FL','Florida'),        ('GA','Georgia'),        ('HI','Hawaii'),
  ('ID','Idaho'),          ('IL','Illinois'),       ('IN','Indiana'),
  ('IA','Iowa'),           ('KS','Kansas'),         ('KY','Kentucky'),
  ('LA','Louisiana'),      ('ME','Maine'),          ('MD','Maryland'),
  ('MA','Massachusetts'),  ('MI','Michigan'),       ('MN','Minnesota'),
  ('MS','Mississippi'),    ('MO','Missouri'),       ('MT','Montana'),
  ('NE','Nebraska'),       ('NV','Nevada'),         ('NH','New Hampshire'),
  ('NJ','New Jersey'),     ('NM','New Mexico'),     ('NY','New York'),
  ('NC','North Carolina'), ('ND','North Dakota'),   ('OH','Ohio'),
  ('OK','Oklahoma'),       ('OR','Oregon'),         ('PA','Pennsylvania'),
  ('RI','Rhode Island'),   ('SC','South Carolina'), ('SD','South Dakota'),
  ('TN','Tennessee'),      ('TX','Texas'),          ('UT','Utah'),
  ('VT','Vermont'),        ('VA','Virginia'),       ('WA','Washington'),
  ('WV','West Virginia'),  ('WI','Wisconsin'),      ('WY','Wyoming')
on conflict (code) do nothing;
