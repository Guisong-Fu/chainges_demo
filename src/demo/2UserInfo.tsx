import React, {useState, useEffect} from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

// todo: Further improve -> I want to to highlight Address. Extract Address from that json, and give it some color~

const UserInfo = () => {
  const [user, setUser] = useState(null)

  useEffect(() =>
    fcl
      .currentUser()
      .subscribe((user: any) => setUser({...user}))
  , [])

  return (
    <Card>
      <Header>User information</Header>
      
      {user && <Code>{JSON.stringify(user, null, 2)}</Code>}
    </Card>
  )
}

export default UserInfo
