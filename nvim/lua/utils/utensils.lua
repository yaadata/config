local utensils = {}

function utensils.empty(t)
  if t == nil then
    return false
  end

  if type(t) ~= 'table' then
    return false
  end

  return next(t) == nil
end

return utensils
