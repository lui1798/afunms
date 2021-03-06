package com.afunms.util.connectionPool;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.log4j.Logger;

/**
 * Explanation: java.sql.Connection getConnection(String name[,time:long])
 * variable name is the name of connectionpool,which is defined in the
 * configurable file. variable time is a optional parameters, referes to the
 * maximum number of millisecend a client can wait for. <p/>
 * freeConnection(String name,Connection con) variable name is the name of
 * connectionpool variable con is the current connection which would be return
 * to connectionpool.
 */

@SuppressWarnings("unchecked")
public class DBConnectPoolManager {
	private static Logger logger = Logger.getLogger(DBConnectPoolManager.class);

	private static DBConnectPoolManager instance; // 唯一实例
	private Hashtable pools = new Hashtable();
	private Vector drivers = new Vector();

	/**
	 * 建构函数私有以防止其它对象创建本类实例
	 */
	private DBConnectPoolManager() {
		init();
	}

	/**
	 * 将连接对象返回给由名字指定的连接池
	 * 
	 * @param name
	 *            在属性文件中定义的连接池名字
	 * @param con
	 *            连接对象
	 */
	public void freeConnection(Connection con) {
		DBConnectionPool pool = (DBConnectionPool) pools.get("name");
		if (pool != null) {
			pool.freeConnection(con);
		}
	}

	/**
	 * 获得一个可用的(空闲的)连接.如果没有可用连接,且已有连接数小于最大连接数 限制,则创建并返回新连接
	 * 
	 * @param name
	 *            在属性文件中定义的连接池名字
	 * @return Connection 可用连接或null
	 */
	public Connection getConnection() {
		DBConnectionPool pool = (DBConnectionPool) pools.get("name");
		if (pool != null) {
			return pool.getConnection().getCon();
		}
		return null;
	}

	/**
	 * 获得一个可用连接.若没有可用连接,且已有连接数小于最大连接数限制, 则创建并返回新连接.否则,在指定的时间内等待其它线程释放连接.
	 * 
	 * @param name
	 *            连接池名字
	 * @param time
	 *            以毫秒计的等待时间
	 * @return Connection 可用连接或null
	 */
	public Connection getConnection(long time) {
		DBConnectionPool pool = (DBConnectionPool) pools.get("name");
		if (pool != null) {
			return pool.getConnection(time).getCon();
		}
		return null;
	}

	/**
	 * 返回唯一实例.如果是第一次调用此方法,则创建实例
	 * 
	 * @return DBConnectionManager 唯一实例
	 */
	static synchronized public DBConnectPoolManager getInstance() {
		if (instance == null) {
			logger.info("DBConnectpoolManager not init yet , now getInstance");
			instance = new DBConnectPoolManager();
		}
		return instance;
	}

	/**
	 * 关闭所有连接,撤销驱动程序的注册
	 */
	public synchronized void release() {
		// 等待直到最后一个客户程序调用

		Enumeration allPools = pools.elements();
		while (allPools.hasMoreElements()) {
			DBConnectionPool pool = (DBConnectionPool) allPools.nextElement();
			pool.release();
		}
		Enumeration allDrivers = drivers.elements();
		while (allDrivers.hasMoreElements()) {
			Driver driver = (Driver) allDrivers.nextElement();
			try {
				DriverManager.deregisterDriver(driver);
				logger.info("撤销JDBC驱动程序 " + driver.getClass().getName() + "的注册");
			} catch (SQLException e) {
				logger.error("无法撤销下列JDBC驱动程序的注册: " + driver.getClass().getName());
			}
		}
	}

	/**
	 * 根据指定属性创建连接池实例.
	 * 
	 * @param props
	 *            连接池属性
	 */
	private void createPools() {
		String url = DBProperties.getUrl();
		if (url == null) {
			logger.info("没有为数据库连接池指定URL");
			return;
		}
		String user = DBProperties.getUser();
		String password = DBProperties.getPassword();
		int max = DBProperties.getMaxconn();
		int min = DBProperties.getMinconn();
		int connectCheckOutTimeout = DBProperties.getConnectCheckOutTimeout();
		int connectUseTimeout = DBProperties.getConnectUseTimeout();
		int connectUseCount = DBProperties.getConnectUseCount();
		DBConnectionPool pool = new DBConnectionPool("name", url, user, password, min, max, connectUseTimeout, connectUseCount, connectCheckOutTimeout, "");
		pools.put("name", pool);// 放置到hash表里
	}

	/**
	 * 初始化连接池，读取属性文件，创建相应的连接池
	 * 
	 * @roseuid 39FB9F19011F
	 */
	private void init() {
		loadDrivers();
		createPools();
	}

	/**
	 * 装载和注册所有JDBC驱动程序
	 * 
	 * @param props
	 *            属性
	 */
	private void loadDrivers() {
		String driverClasses = DBProperties.getDrivers();
		StringTokenizer st = new StringTokenizer(driverClasses);
		while (st.hasMoreElements()) {
			String driverClassName = st.nextToken().trim();
			try {
				Driver driver = (Driver) Class.forName(driverClassName).newInstance();
				DriverManager.registerDriver(driver);
				drivers.addElement(driver);
			} catch (Exception e) {
				logger.error("无法注册JDBC驱动程序: " + driverClassName + ", 错误: " + e);
			}
		}
	}

	public Vector getPoolConnections() {
		DBConnectionPool pool = (DBConnectionPool) pools.get("name");
		return pool.getPoolConnections();
	}
}
