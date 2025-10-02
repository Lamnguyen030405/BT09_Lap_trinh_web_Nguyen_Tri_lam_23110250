package vn.iotstar.entities;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "videos")
public class VideoEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "videoId")
    private int videoid;

    @Column(name = "active")
    private boolean active;

    @Column(name = "description", columnDefinition = "nvarchar(MAX) not null")
    private String description;

    @Column(name = "poster")
    private String poster;

    @Column(name = "title", columnDefinition = "nvarchar(255) not null")
    private String title;

    @Column(name = "views")
    private int views;

    @Column(name = "user_id", columnDefinition = "INT")
	private int userid;
    
    // Kết nối many to one với category
    @ManyToOne
    @JoinColumn(name = "cate_id")
    private CategoryEntity category;

}