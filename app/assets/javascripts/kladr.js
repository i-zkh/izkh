$('#input-city').kladr({
  token: '5322ef24dba5c7d326000045',
  key: '60d44104d6e5192dcdc610c10ff4b2100ece9604',
  type: $.kladr.type.city
});

$('#input-place-city').kladr({
  token: '5322ef24dba5c7d326000045',
  key: '60d44104d6e5192dcdc610c10ff4b2100ece9604',
  type: $.kladr.type.city,
  select: function( obj ) {
    $('#input-place-address').kladr('parentId', obj.id);
  }
});

$('#input-place-address').kladr({
  token: '5322ef24dba5c7d326000045',
  key: '60d44104d6e5192dcdc610c10ff4b2100ece9604',
  type: $.kladr.type.street,
  parentType: $.kladr.type.city
});

