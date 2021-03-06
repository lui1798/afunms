package com.afunms.polling.snmp.hdc;

import java.util.Hashtable;
import java.util.Vector;

import com.afunms.common.util.SnmpUtils;
import com.afunms.indicators.model.NodeGatherIndicators;
import com.afunms.monitor.executor.base.SnmpMonitor;
import com.afunms.polling.PollingEngine;
import com.afunms.polling.node.Host;
import com.afunms.polling.om.HdcMessage;
import com.gatherdb.GathersqlListManager;

@SuppressWarnings("unchecked")
public class HdcEnvironmentStateSnmp extends SnmpMonitor {

	public void CreateResultTosql(Hashtable dataresult, Host node) {
		if (dataresult != null && dataresult.size() > 0) {
			Vector sysInfoVector = null;
			HdcMessage hdcVo = null;
			String hendsql = "insert into hdc_environment_state (dkuRaidListIndexSerialNumber,dkuHWPS,dkuHWFan,dkuHWEnvironment,dkuHWDrive,nodeid) values(";
			String endsql = "')";
			String deleteSql = "delete from hdc_environment_state where nodeid='" + node.getId() + "'";
			sysInfoVector = (Vector) dataresult.get("eventlistState");
			Vector list = new Vector();
			if (sysInfoVector != null && sysInfoVector.size() > 0) {
				for (int i = 0; i < sysInfoVector.size(); i++) {
					hdcVo = (HdcMessage) sysInfoVector.elementAt(i);
					StringBuffer sbuffer = new StringBuffer(150);
					sbuffer.append(hendsql);
					sbuffer.append("'").append(hdcVo.getDkuRaidListIndexSerialNumber()).append("',");
					sbuffer.append("'").append(hdcVo.getDkuHWPS()).append("',");
					sbuffer.append("'").append(hdcVo.getDkuHWFan()).append("',");
					sbuffer.append("'").append(hdcVo.getDkuHWEnvironment()).append("',");
					sbuffer.append("'").append(hdcVo.getDkuHWDrive()).append("',");
					sbuffer.append("'").append(node.getId());
					sbuffer.append(endsql);
					list.add(sbuffer.toString());
					sbuffer = null;
				}
				GathersqlListManager.AdddateTempsql(deleteSql, list);
				list = null;
			}
		}
	}

	public Hashtable collect_Data(NodeGatherIndicators alarmIndicatorsNode) {
		Hashtable returnHash = new Hashtable();
		Vector eventlist = new Vector();
		HdcMessage hdcMessage;
		Host node = (Host) PollingEngine.getInstance().getNodeByID(Integer.parseInt(alarmIndicatorsNode.getNodeid()));
		if (node == null)
			return null;
		if (node.getIpAddress().equals(""))
			return null;
		try {
			String[][] valueArray = null;
			String[] oids = new String[] { ".1.3.6.1.4.1.116.5.11.4.1.1.7.1.1",// dkuRaidListIndexSerialNumber
					// dkc 索引
					".1.3.6.1.4.1.116.5.11.4.1.1.8.1.2",// dkuHWPS
					// 缺陷名称
					".1.3.6.1.4.1.116.5.11.4.1.1.7.1.3",// dkuHWFan
					// dku 风扇状态
					".1.3.6.1.4.1.116.5.11.4.1.1.7.1.4",// dkuHWEnvironment
					// dku 环境状态
					".1.3.6.1.4.1.116.5.11.4.1.1.7.1.5",// dkuHWDrive
			// dku 驱动状态
			};
			valueArray = SnmpUtils.getTableData(node.getIpAddress(), node.getCommunity(), oids, node.getSnmpversion(), node.getSecuritylevel(), node.getSecurityName(), node
					.getV3_ap(), node.getAuthpassphrase(), node.getV3_privacy(), node.getPrivacyPassphrase(), 3, 1000 * 30);
			if (valueArray != null) {
				for (int i = 0; i < valueArray.length; i++) {
					hdcMessage = new HdcMessage();
					String dkuRaidListIndexSerialNumber = valueArray[i][0];
					String dkuHWPS = valueArray[i][1];
					String dkuHWFan = valueArray[i][2];
					String dkuHWEnvironment = valueArray[i][3];
					String dkuHWDrive = valueArray[i][4];
					hdcMessage.setDkuHWDrive(dkuHWDrive);
					hdcMessage.setDkuHWEnvironment(dkuHWEnvironment);
					hdcMessage.setDkuHWFan(dkuHWFan);
					hdcMessage.setDkuHWPS(dkuHWPS);
					hdcMessage.setDkuRaidListIndexSerialNumber(dkuRaidListIndexSerialNumber);
					eventlist.addElement(hdcMessage);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		returnHash.put("eventlistState", eventlist);
		// 把采集结果生成sql
		this.CreateResultTosql(returnHash, node);
		return returnHash;
	}
}