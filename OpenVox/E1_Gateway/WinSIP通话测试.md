## 长时间通话测试

	使用 WinSIP 对 E1 网关进行长时间通话测试

### 呼出测试+V100编码测试

	WinSIP(g729) -> AsteriskServer(8888) -> E1 GW(8888 默认编码) -> E1线路 -> AsteriskServer -> Playback

### 呼入测试+V100编码测试

	WinSIP(g729) -> AsteriskServer -> E1线路 -> GW(8888 默认编码) -> AsteriskServer(8888) -> Playback
