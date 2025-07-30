package org.springframework.samples.petclinic.owner;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import static org.assertj.core.api.Assertions.assertThat;

@Disabled
@SpringBootTest
public class OwnerRepositoryTest {

	@Autowired
	OwnerRepository ownerRepository;

	@Test
	void shouldFindConnorKenway() {
		Page<Owner> connorKenway = ownerRepository.findByLastNameContainsLocked( //
				"Kenway", //
				PageRequest.of(1, 2, Sort.by(Sort.Direction.DESC, "id")) //
		);//

		assertThat(connorKenway.getTotalElements()).isEqualTo(3);
		assertThat(connorKenway.getContent().size()).isEqualTo(1);
		assertThat(connorKenway.getContent().get(0).getFirstName()).isEqualTo("Connor");
	}

}
