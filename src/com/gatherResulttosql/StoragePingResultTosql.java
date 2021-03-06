package com.gatherResulttosql;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

import com.afunms.common.util.SysUtil;
import com.afunms.common.util.SystemConstant;
import com.afunms.polling.om.PingCollectEntity;
import com.gatherdb.GathersqlListManager;

@SuppressWarnings("unchecked")
public class StoragePingResultTosql {

	/**
	 * 
	 * 根据采集结果生成对应的sql放入到内存列表中
	 */
	public void CreateResultTosql(Hashtable ipdata, String ip) {

		if (ipdata.containsKey("ping")) {
			// ping
			String allipstr = SysUtil.doip(ip);
			Vector pingVector = null;
			PingCollectEntity pingdata = null;
			pingVector = (Vector) ipdata.get("ping");
			if (pingVector != null && pingVector.size() > 0) {
				for (int i = 0; i < pingVector.size(); i++) {
					pingdata = (PingCollectEntity) pingVector.elementAt(i);
					if (pingdata.getRestype().equals("dynamic")) {
						Calendar tempCal = (Calendar) pingdata.getCollecttime();
						Date cc = tempCal.getTime();
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String time = sdf.format(cc);
						String tablename = "pings" + allipstr;
						String sql = "";
						if ("mysql".equalsIgnoreCase(SystemConstant.DBType)) {
							sql = "insert into " + tablename + "(ipaddress,restype,category,entity,subentity,unit,chname,bak,count,thevalue,collecttime) " + "values('" + ip
									+ "','" + pingdata.getRestype() + "','" + pingdata.getCategory() + "','" + pingdata.getEntity() + "','" + pingdata.getSubentity() + "','"
									+ pingdata.getUnit() + "','" + pingdata.getChname() + "','" + pingdata.getBak() + "'," + pingdata.getCount() + ",'" + pingdata.getThevalue()
									+ "','" + time + "')";
						} else if ("oracle".equalsIgnoreCase(SystemConstant.DBType)) {
							sql = "insert into " + tablename + "(ipaddress,restype,category,entity,subentity,unit,chname,bak,count,thevalue,collecttime) " + "values('" + ip
									+ "','" + pingdata.getRestype() + "','" + pingdata.getCategory() + "','" + pingdata.getEntity() + "','" + pingdata.getSubentity() + "','"
									+ pingdata.getUnit() + "','" + pingdata.getChname() + "','" + pingdata.getBak() + "'," + pingdata.getCount() + ",'" + pingdata.getThevalue()
									+ "',to_date('" + time + "','YYYY-MM-DD HH24:MI:SS'))";
						}
						GathersqlListManager.Addsql(sql);
						sql = null;
					}
					pingdata = null;
				}
			}
			pingVector = null;
		}
	}
}
