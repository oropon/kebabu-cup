vm = new Vue
  el: '#app'
  data:
    newMember: ''
    members: []
  methods:
    submit: ->
      vm.members.push
        name:vm.newMember
        team:''
      vm.newMember = ''
    remove: (member)->
      return if member.team != ''
      vm.members = _.filter vm.members, (m)->  m.name != member.name
    group: ->
      vm.members = _.chain vm.members
        .zip do ->
          _.chain [0..vm.members.length-1]
            .shuffle()
            .map (n)-> String.fromCharCode(0x41 + n%8)
            .value()
        .map (e)->
          [m, team] = e
          m.team = team
          return m
        .value()
    sort: ->
      vm.members = _.sortBy vm.members, (m)-> m.team
