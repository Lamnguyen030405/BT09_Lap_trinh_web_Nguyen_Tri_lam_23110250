package vn.iotstar.entities;

import java.io.Serializable;
import java.sql.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "users")
@NamedQuery(name="UserEntity.findAll", query="SELECT u FROM UserEntity u")
public class UserEntity implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="username", columnDefinition = "NVARCHAR(100)")
	private String username;
	
	@Column(name="password", columnDefinition = "NVARCHAR(100)")
	private String password;
	
	@Column(name="images", columnDefinition = "NVARCHAR(MAX)")
	private String image;
	
	@Column(name="fullname", columnDefinition = "NVARCHAR(100)")
	private String fullname;
	
	@Column(name="email", columnDefinition = "NVARCHAR(100)")
	private String email;
	
	@Column(name="phone", columnDefinition = "NVARCHAR(20)")
	private String phone;
	
	@Column(name="roleid", columnDefinition = "INT")
	private int roleid;
	
	@Column(name="createDate", columnDefinition = "DATETIME")
	private Date createdate;
	
	@Column(name="code", columnDefinition = "NVARCHAR(50)")
	private String code;
	
	@Column(name="status", columnDefinition = "INT")
	private int status;

}
