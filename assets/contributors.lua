-- {{< contributors >}} : print a document's people, grouped by role, as a
-- heading per role followed by a wrapping grid of person cards (name, email,
-- affiliation, ...). Styled in assets/css/styles.scss under .quarto-contributors.
--
-- Reads its own top-level `contributors:` metadata key (a list of people, each
-- with name/email/affiliation/roles/orcid/url) — a custom key, independent of
-- Quarto's built-in `author`/`authors` key, which this shortcode never reads
-- or touches.
--
-- Optional: filter to specific roles (case-insensitive) either as positional
-- args, {{< contributors analyst pi >}}, or as a comma-separated kwarg,
-- {{< contributors roles="analyst,pi" >}} — both build the same filter set.
-- People without a `roles:` value are grouped under "Contributor".

local function stringify_or_nil(v)
  if v == nil then
    return nil
  end
  local s = pandoc.utils.stringify(v)
  if s == "" then
    return nil
  end
  return s
end

local function esc(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

-- A metadata field can be written as a single scalar (`roles: "Analyst"`,
-- even multi-word) or as a real list (`roles: [Analyst, PI]`). pandoc's own
-- type introspection tells the two apart reliably, so each becomes 1+ strings
-- here without any word-splitting ambiguity.
local function stringify_all(v)
  local out = {}
  if v == nil then
    return out
  end
  if pandoc.utils.type(v) == "List" then
    for _, item in ipairs(v) do
      local s = stringify_or_nil(item)
      if s then
        table.insert(out, s)
      end
    end
  else
    local s = stringify_or_nil(v)
    if s then
      table.insert(out, s)
    end
  end
  return out
end

local function contributor_name(c)
  return stringify_or_nil(c.name)
end

local function contributor_roles(c)
  local roles = stringify_all(c.roles)
  if #roles == 0 then
    table.insert(roles, "Contributor")
  end
  return roles
end

-- Ordered list of { text = "...", link = "mailto:..." or nil } to display
-- under a person's name.
local function contributor_meta_lines(c)
  local lines = {}
  local email = stringify_or_nil(c.email)
  if email then
    table.insert(lines, { text = email, link = "mailto:" .. email })
  end
  for _, affiliation in ipairs(stringify_all(c.affiliation)) do
    table.insert(lines, { text = affiliation })
  end
  local orcid = stringify_or_nil(c.orcid)
  if orcid then
    table.insert(lines, { text = orcid, link = "https://orcid.org/" .. orcid })
  end
  local url = stringify_or_nil(c.url)
  if url then
    table.insert(lines, { text = url, link = url })
  end
  return lines
end

local function matches_filter(role, filter)
  if not filter then
    return true
  end
  return filter[role:lower()] == true
end

-- Build a { [lowercase role] = true } filter set from either the shortcode's
-- positional args (each its own role name) or a `roles="a,b"` kwarg. Returns
-- nil (no filter, show everything) if neither was given.
local function build_filter(args, kwargs)
  if args and #args > 0 then
    local filter = {}
    for _, arg in ipairs(args) do
      local role = stringify_or_nil(arg)
      if role then
        filter[role:lower()] = true
      end
    end
    if next(filter) then
      return filter
    end
    return nil
  end

  local roles_arg = stringify_or_nil(kwargs["roles"])
  if not roles_arg then
    return nil
  end
  local filter = {}
  for role in roles_arg:gmatch("[^,]+") do
    filter[role:match("^%s*(.-)%s*$"):lower()] = true
  end
  return filter
end

local function contributors_shortcode(args, kwargs, meta)
  local contributors = meta.contributors
  if not contributors or #contributors == 0 then
    return {}
  end

  local filter = build_filter(args, kwargs)

  local role_order = {}
  local role_people = {}

  for _, c in ipairs(contributors) do
    local name = contributor_name(c)
    if name then
      for _, role in ipairs(contributor_roles(c)) do
        if matches_filter(role, filter) then
          if not role_people[role] then
            role_people[role] = {}
            table.insert(role_order, role)
          end
          table.insert(role_people[role], c)
        end
      end
    end
  end

  local html = { '<div class="quarto-contributors">' }
  for _, role in ipairs(role_order) do
    table.insert(html, '<div class="quarto-contributors-role">')
    table.insert(html, '<div class="quarto-contributors-role-title">' .. esc(role) .. "</div>")
    table.insert(html, '<div class="quarto-contributors-grid">')
    for _, c in ipairs(role_people[role]) do
      table.insert(html, '<div class="quarto-contributors-person">')
      table.insert(
        html,
        '<div class="quarto-contributors-person-name">' .. esc(contributor_name(c)) .. "</div>"
      )
      for _, line in ipairs(contributor_meta_lines(c)) do
        if line.link then
          table.insert(
            html,
            '<div class="quarto-contributors-person-meta"><a href="'
              .. esc(line.link)
              .. '">'
              .. esc(line.text)
              .. "</a></div>"
          )
        else
          table.insert(
            html,
            '<div class="quarto-contributors-person-meta">' .. esc(line.text) .. "</div>"
          )
        end
      end
      table.insert(html, "</div>")
    end
    table.insert(html, "</div>")
    table.insert(html, "</div>")
  end
  table.insert(html, "</div>")

  return { pandoc.RawBlock("html", table.concat(html, "\n")) }
end

return {
  ["contributors"] = contributors_shortcode
}
